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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Є/z����R3&=��IC�#�\VZ�t��w�vՙ���{�������e�;��CN�|A3��'�P-B�S`���]�@�N�� K*��BM���Z����f��vL�Zq@��az�	(Q<��� �$�����^yL�@N�Ȧ�xPz��4�i����[�Z�
:�ʱ��4c?��a{)�5͡�~�2Ւe�������
[��òή�U��3�,{�~b�.�M�����G{x?~w�~i��:���7�}�)�p�mNhWm�ʏ�ʊI���i�F����%Xdg~�r�X��X_E�=A�B>�ɍ��'1Ͼ0dP�u4�)$��KGa�vԎ�h@xA�zb�:m��\���cg�5Q�����@p�M���:Lj{q�Mr)��6B\ݐ��0�Բ��$m���j%N���C�ʁ���ŬK�A$��\׻���S�����#V|9�c�]ڻ����hfI�gW�=�C]�p�@!�b�i�5����H����O�{́*���C��R����a��s�0��Z4g$��4���"�ה�˩���V�X=J
+���6��GZ�)P��?���"�q�j7�]���d3��0/j�BH|k���;v�/�Z�y,Ĩ��/+��I[D5��O��fi)�j��u�rt�+p���W���cH��E�tHx�^g̽�Dޓ,���yҾiW�Bl����B������-�7E���U,2_;yR�hÛ+�u{�̈́����=	��
h\��S�PZԢ���xmc�%aZa��p�������^l�䙴��j�y�1��f-�G�ԉ;V�o�s|+�n
���:+hW�4�1��z��f�[�.��J�q(��f������_�n��bNیeJ�� ������"�&���r���ӕKt�7<�� )'8�W�������Y��.N�,�L��Fd�4��CL38��O�3�`�=��h�v���5oR"�|� ����l�"����n$-Z���<�]Qj��4��a��b�����"ב����&�,b^ͪ4NoN�	�p��+D������6֞xm�,�9 �]��;Tq�b��ؖ�1��v}���N4֜�3a| �Y��'�4d��UB#ܽ�[��E�E���Q�8�V¨��.mلf-H��j���Q\u��[�u�F
��i��\X@��b�fL�;p�
Y�!d�q�E���Y�����#b)�D�zGB�U���a���U�]u�5�a��~�P]4�5{o�ͣ�QIE��sC�TW� 2��+���/�
���Z/�a.�v�o�n�L��/����x.̒A����Ў/�'Q?ѝr�i��gT����j�,���+j������������c\3k�n�1�~�2T�<�5��H[���[�!d�4�d��:�8���	Zt�h�z�g>�HB3�*`�/:^u�b��n?����o�C3�%m�uPheϤ�Y��8�6I+��O�{L�%��'~�aG,9�Ă9<`��n��Ah�ߊE�Ͱ�G�s�8�R�\���S>�o=A;FÖx�Y�6}���^]v���X�Z�eU�(�g}U��}�~6tXk\4xi}�N��z�?�)�3j�9� 2�֤�Y! �y�ID$���F���H���"��!g��
�&����mN7�8xב��,U�Sa0d��^��o����U�M�0[��	mK����ٔX�v���e���>��*���v�`mf�Z��Ѝʖ0��� �Nu�<���Y�I� ��_�e«��Q�|���lA�狣ߗ�����b����vs �<���+�W4�.�:r��s{y%u�-���J�j��4�H������*l��J����
{
i�u�@�t������j:���.��t�L���L;��%K��N��N-�y�{\_�S�FDR�`��y9~��5�������~5���ܔ�X�up*Y�v�՗�ޕ&Ɔ���eP��,�X��L����q&Ly��$���$%xI��I�e|��^�"e����R~�X�����s�����L���勤�0��P.��&2jZ��i]a_����ˋ�q��ɕp�;w3B��L�}�'PP��^���S�50�ro��q9Q)�o?��LS�<q���_l~�Sr1G�xx��j�AM
����)r�K}Ǘ�v��4�:K� w��/��..,��[{�nK.�è�GV�����>���F&��Ba;B&�S���De�*���1�ھS���qI�S��㐖��R/��|47䏒���p�j���'���@�:�@j�u|�����A3�h7~J����>?pP1� ���&0	���)2�k/w���l'r�n���Ф3J@2:�(�=2���;��j��@�������Ej4����Խ�"�.�K�����l��:�l�d`�j�ks!P偳�9�Qa^ڇ�J�"�\>I��BkR����%:k��������t�$��KY�w��o���W��؎0�xE�0j�h����K5�_-Z���N�|��3M�o)��|���W�X�;a���!�1N�*�_��8z���	�����	�!��S�v��V�O�Bl��ګCd �M��u�"����8Ցcx���wm���ڗ�T���C��7@ӪR�����1l�ጷ���9N;uR'����5A��RV#?|rӥ760@	}xcIC�<����F����i�>ψ*��a�����%�Ij40�m�`�����Ď ���Y8�r�� |�Jl��l�Z��r� *]<P� �̛�M�ǒ�}ӯ-��w�%'p�{Q���T�%��\��Z��j�	��=�"eB���o֊1^���s\�Ǆ��gm<p���&~��G�����'MSY�����[;w���.��"k��0=���Éq"�� �`���r���qTb�\K��T�A�ϲHژ&�]�Ӥ����"C3���$�!/����R9		W�s��_�I�e��fS�d?>��'p{�{�3H0
���s"���2�Ƹ6�^����6�UOA���i�1���J����W -�^�����ڳH��x�l�ʙIo� |�:���?a!UN'e.H��-_;��g�fn��?���iu��^�!�r94�[�J��� e��N/fx��A�D@���Bp�u�rh>�j�"����4ʋ�J��*}�D}�&Z鳀���Ȋ��!J�2b���ڌq��Զ�]Ln������v`�l�ؿ� T�N��S���q��˒Nq%�#Rly��B�*�%x�d�N�W�����/Z����S,6�� �ȴ�$o\Dl(�=�c%0���b�Ջ�.��Tob�cݩ�Z3HÆ��P�N5�Y�� f\���S�B���-�t>��P��؝D���W]�[�oΔ��������F���$!�������0O9
B���j�:���0I��[���+��F/}��� VT�J��1U�qD����0u��U3OB?����#;�����O�L�%( HQ����:��ɇڵ�V�gb1��'D��m`�C�o�],M|#����Z�w0��w��t���M4�X�2p���ۏ��#Tx������)b������+���|7�ae[��s��)�ߛ��>,zQ?��S�������E�Q���~k�޿��h��"��6�p��� ��`o�]n�u��t�%?��Z������X\�֮�Q�F�jz[�}��Z�2�����p�HkWA�'<��
$drL��RԔ.�g�qڡ���7����#�i3L����^�Q��,��[JV$�7�߱
t����z�VP)�	T��3)�ס���y��c�*�NО��$"��`$���)�*�\�=Ϲ�Di*�v��)���;�b�Io=7�#7�����YE��M^2���Tk�8Nմ�O3����r�I���Wm�&B�Ս ?,g�G?I4�G���?P������eS@����~�[i�B��BA�U���"�e	�'�g[Uꪆ�}D��X7��ʩ