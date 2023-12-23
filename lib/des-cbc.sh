#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў����B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}�����az��6\̊1��v�39�{��_�S0jTs�'������_Cq���lvq����x��`gV�� �t̫���yD�tJ��I5�&o֛{��]�?S�t<$�`2��OT{p�m`5��詯3{#��h��1#%�`/Ԉ�]l��1:%����O��[ַ�+qA^��aJ彤9U��ӏ�4�)�W�h���k�ӽ\u6,&݃���I������G �^@�dݧ�?c �[�w�QE=fԻY6 	���Y�`��4]�&80痺a�"���@kݤ"Ld;���@�s�fJ����+���tΕ��+K�)G���ĩg:���C~��iS���%�Xs���h� ��Z�doP�!�ȊZ��� �+�����OT�;�x��xB83{+���/6�O��w͡��?7�ۙ���i;>���c�0`��.�Z�j���یJ��+�w6�&}�[�"\��6##�mM���[$���A-�#*�{����ː�:}�hƶ�\d�u�%��Jl���;�����"��ZuR�4�]�F��t�'�5�@�(�7[M��Ʀ	�����c��?��w��':�C	}̆U��Fd�|-C��Q`�H�����6��JgA�fR�?6š�W%(��F��L�
ܪ����1c�r��D�վ�!0VO8^�E���^� +^�E�}hi��؁a�oA�X��\^F�⬡ ���\�˫y?���T+R��6�d=2�
/�h��Iw��Yύp�՟�Р�=w��	Imj?�G`����j�FAP�'�=9�1ȸ95X��y��ލ�q�N"�&���/P��m���-�qyϖa+G��j[�P�&��B�{��cU�`�
���w�!��W��$�Ư��%�>��#�W������IyR�`�9�9>���q����(<}�bx�� ���{��v	�uR9;{��n���֛(�H�J����#4χᗟ�@��,~����Q������Ɔ̫�-�pڽ��<B��N�[�84��9Mp�t��x(��$&��^�-���{)p�·�.g�7��b���5#�E�.��[������S���K��o��/[���1�wC�	�hbҦ�EK	��2!P����~At��H-<��?@:k}�+�P�M����e��I�&�Dx���y�j�d�0F���(��g��Q���������l�1��80^�ף~��ߢ/��	#���h�"��W.�x�6RRAu�`�H7���ކnA)r*��>'�!����NL)/�W���&�Ѯ(�.dtG��@s�h����m5��ez��y�,e吺�^����E�m�I�B�f�!Ԑ�2,��+���ix3?��U� �w��~D�$�^)���7j��jM��}����(I���y�݄NS,�M�ͬAd)��L�n���������m4�)9�q�����K�"L����e� t���	;�t+YQ^g`�!��ɧ���;xbނ�UIZ����Wa�jr؀K�VǦ�O_	��Y�}I�S�kt+��g�����]����_sm���x{>���ibcZ� �Z�<�Qf�����l6��E����t3g���m�q!�ٝ�]n����٘S�;�f
�M���t�什�S�*�r;dUl.��ŷ�sגܲ�ֻ42q�#��{1M�'ng���4�_r٢���m@~���j�yڷ�५ܚ�朔[�Uˤ�D��ye������n�`��!���CE�F�ryڽ@�m���D��v�qWy��bՑ`�P@�ߪ��W�����rS���Y�Ǖ:)Rͬ��t{t�D���*��i!�����hhQ���1�R��B�j�����n��-�8ݸ�Q�,�`���`�5�6��t�! �wC��>�l�
5P_�?m�dބ�2���|�r! ��0��⓰�(�\. ���W7���6չUE%�[H���W{��V�W���sD�[K�9uN���l�րu*{��+�Y�`��$$gx6���E%v��4�/�W��?c��w��[W 
�@+ɠn!Ը�e����pi��)n�z� Zנ��3�{��C+ݢ;��^|1�:6�p�!v��j�tҁ"?-R�Z6�Y�� �s��	�1�i&�S$�9�e�*�R2��zpPW�DÈ���;")��ru��23�>+�Bh��(����~�HT��[����긾�oPL��N%Z�UM����S(rl�:��J����Z��?J˦��������l���vҸ%<mO��4�rR�����!o8�)2���b�����D����(�f����5A������'���J�x�!��d��}�#����b�J��8;aĥd��'YlR�Q��cgޣ�����x'�������ץ]ro�@BΑN���i�X��am���u�̽eͯ����%��;4�s����ۀpW�u����K.l��r K=��[��/��1 j��-����7��2�ŏ�wf�E�����֜1N�1 �q��&�nrAN_l#�C�	g.��gl�kx�#��=�e�e\_"֛�ݣ�:�����xA���i��Amn��s������oR�ͼOܾ>�qd�/��\TGy!x9����q����^�����q��c�������~F�	���-�XJM���{K��&��pf�~��R�*e )�ye��[�NOI�����}��O͡�t�� 3�p�5L@L	g��$j6�iy� T�%�5)[��0��07�$���!e˴�\f�2�Ǆ@�>+~ҍC� ��_�/�6�E�����������9�ͦ��`�E�l��$B�;N��.=��X�$$m��@�νv,�O���&�&��=��.�a��ޕ��֤��QQ�^ ��)~˟n�l�4|�P�B<qb���I<=�p�/c�׭�n8��2aվм�\(��T��C�c1O?H{��ތ7~�A-#M��(�f V삸�N1��M�+U�a��Q���Y�c8���sK�Ɔ�;�ӞB�ޗ���~�W8e}\�X�|�-�Q=��@���Da��G��|q_Pt��뿮���އ�cO�i(_0��N~s�ð��Z�Zw2�$������\�~.~�p�!;,R��$?}�1�<[j!aR����1�h��3����+�3���k� \s�\Jk�)�u��l��{�>ɧ�F9X����N.�Le�+d C�'�1��bԍ?c��l�Ƒ\�#B�T�˽�!�'XmȦ���:�>����}0s�aӌ���ҫ=Ȃ�؛;�(���~�?���Ԟ���e=�$&(iݯ�E���0
蒗}�a�]�-����@�n����&L���ìcP ���8�D]7;W͠S��S�[��w
���rH����S)Q]���{����������b\�p��72!0.��Ԡ�u�j�q��`)nD�6�*ƣ*�T�+�#M�l�䟷D�V#���PM�+��k�Z�j�M�f��Ns�)y������䧡��B�}ƹ���aen���<��GT�s,UZ˞½�:��o���"C���٦���`����!�;��p׽F�"�t��)5C���&��v`�lN�������u��Q�Ot���1���pPCB�c��ҏ�x�, ^�|����[�;z.�Y��b��k1E�4��S� ��4T�f˰�}���H�o�?� æuwlד������,MGv������)�a��I�,IԠ�)� �)�������J����5���a[���A�O+��k^��A^�Zn��c��R��M��&�`u/�Uڀ�I���yd
��$$�5Y���[�~�D��ڤ���ëk�L�F��Q��i�ru�r�&yXzFY�?^�8�2���ݎ�e��M�zYG��a"g|�ܷ��%	����F��=��;��EN�9�q��'�����:gq�B���Q>��u�ҷ��� ����[���_�`����t��܃)�1��! �w}��M�Ε�����