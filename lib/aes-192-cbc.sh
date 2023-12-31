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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ\���Ʀ�2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	�ӢJ�^���j݇׾X� �}���9������!'����N"^1�@�4�'��>�I���g��(4W��9��������_��Ӫ��L�\Je)�nBf�Yb���r���9F����!��9݅������]�u������J���8��,+��N���mE����Qe�]	��/���t�Oi�a����B��ϼ&׫�]�l�7#y�,-ݩ�nj���ׅ�x�Bঘ��G-�OTF�z�q�/@���@"�kv�\m������I�Q�U�e_PV�	Q6��йM�/Ϫぷ���9O�{��a���@����Z�M����3x�Շ�Pzf!���o�lB����|�s��w�|�Mę�[��K�[εB*lIDg����`y��G,\��7ι\����b���Q���4$����p�����ءG�u�=�Q�'�𖌄^t��1kMhnx���p�ڐ���ODI`vx��>G���	e�����kU�!i :P{��J]�7߁Os�ڇ�fJ2��J����G����̘�/(P�V�WZܼuØ/ Q���@ӔM~G���4]S�����?>j��s���Wr��Vq��x�'��k�Z%�V�滒F�
���&,0���aܹ��8K1ͯ����1�P^Q�T�-�jeJH��������ԅ��XQp�*�g�Zd��>�ב>Wu��U3:��/����G�V�����ӛm40����!8̈5���4�e�D��/�Fq6�~�
�S�S�\�2���DB1���G�	���%�z"��N�N��=�'8�μE�H>��1��fp���UoznI��J����S��S�7Ъ)�^ni���4"���ulxE�dv`��G;
uE{e�u0P�X��C�I�_bN�g�/oh�{(k��� ��]Z�d�M@igt�9XE.fTxwd������ ]r�P�W�h�81P�c�p �p"_��4���y��k�oh����X23���t�x�R�މH�a%��>Y��1B����׉�IX_��R$X�}	n|W�w4E�5L���вv�e����h�$h2@�S���:�ܾ��;�3T�6*[m�������0���ءu��md�a��Ϟ��':q�I��8�|�a�s�hM��%���9�rٴ��E�0�(?�]���rT���O��`ֈ��ڲ϶Z�/D`��s��D��9�2Q�KUQ�������:���߱
��QɈY	$S����{X8���q���*?�3)'Ƨ���o$�[�1�����P��Ӄ�n"v&y{/JW���9	n 7�J��x{g�^M�~ܬt�r/R'''+��4X�w�n���=����K9o�h^�:�n�-0��{��5E�6��e�ov;��"8QJ��L�\��q����[\G�����a
��L9y��#�͗�B��:|g*%��ቧ�Z"�|���aX�3W�2��W��(/�c��~�/���ta�20����,���Y芣]?��,7�n�r���RfnX�Ǟ�9�dM!����~�z�O�n�mַl�����,�zP�?��W�P����b�jL�!�Bbln��vB��Ē���R�pDf�c�%r3��U���~!�7����k�x��@Jk�SM|��k- G}�z"�5�X�:�̬z����K6�ެ�AC=�;�ɜ�tb����Ij�55ֺw��n��A��wG��I��Zc�@�"t�_DPr�z;�<�T+�M+{&�q���z��b�eg���O]��!I�I��<&�E�&�n0F�H
�؇�&��MG{;�u�	�έky�I���=�%�[�Y&(�wt���9۩���6�A���3bW���$0���a_���h49�?��i�pI��u��R	*ڐ ��v6���F�����
���|g��e\�ƈ�v叻?�s9��;��A����AaC�H�4����w
�1]�g�[�o�K=֚������G���ߒ7��^՘3�";:�)�y~��^-%� T'�02l��D�
l&�z!�����\d�b���#%]�V}bp�J%��հ�zގ�i���[�х�K&ڭ�rk<WM����$�p���˕�9	L0.l�J�j�L"��:��X���u����"6N���.�"���c����%�^���nK3�Ȫ&'Y���c��s�-���֢�كX��Qʶ��¨���NNm�>�k]�!����7��������J�b@��$E�F��Z���'4xI-g��a?E\%I枮��x���q#��6����p]o�3����	f?� ��� ��u-��+�2`�6�Z��9t�{�|���$cd�+Y�m�9s�,EDGv�4��|e��"k� ��/���r�6Qw�*q�!b��`XI�q�f=,�c1���؛A0��ơ�[Q���P��*<���SA��-���G�#�e�P��D���V"Җ�iQ�w2��5���Wе��B�MQ������~�$�j���hc�f�������Y>Ha��XVrπ7&b�^�~�v}oa��)�%k#D��O��PM7cT��ߥ�]�5)�-��M˥��Q�m7�5k�wA�Y<; *o]`!�rk�[��x(�� C���e�{�᰻Sm|`D�����N�ᝧ�������P���e�ӭ��}Z�ůc��1�e˫�M��,�àzIIn�/Ѱeu���I��3�у8N�j��*[��v�)v䕱��Pf�V'~䢍� GbN�7(��F
���r�&8��wl���Z�g=$s��O�6J�bͨ9���s�Hub�����#�v���G��I�6K�oM�w���2�?�M�� D<��W2Ph�/V2/�*N�'Ny+w�����զ_S�10��"��D���擜��*�B�0ٹ�E����S�<I�LkJ�W��E���\�2���9�kl����߇ǅ�{�g��¹�r (���J���R�1B�m�\�)e
�9�}��]��]�\ZтP���X�2=��Q⇂��i�^�����������"�'��0qVa�R�o�Мa ���܈�Wl�ʨs�4�5�X��>�����hԆJ�b�UE�����_)�>��������oo��^����@=���`�ն�=O�'��>�k�q���#�`��1B�/����vSC��E6W��
F�@�������l�: 1|8��(��3#|1��6ϕf�e��V7�H�T�a���Blts�P�ɕT�K2w��� �F��>��9���oI�����2�me�+Ѥ�G6ɪ�/�tR�̤c�������]A]&գ���Қ�K�c�x$R� ��.]�����/�>�N��@��'����Rɦҋ�Í���I�n�����J��r�E���b:M1�}cK�!�3]w����!f�d	XLAq��z(�4���H�\��_pUԐ�U���Ի�Ր~q�'�����2�y)���ǝ�~���x\�7nM~�]y� �E-]'���� ��oBk�2��&�m����=-�n@�t�&�`�#�γ!�4��O_��o��OD�R�j�7������&.܈�9i���1K�3_�(T������b��r�eXFHO �G�{g��.c�r���[ɝg�"�
.0!6�v`D��p���GztAD��d�T��"�7���w��w�V�Fu������l�v�@P9k�';�G0�<O�޶&�6��G��=-��ʩ�&}�!C9r8'�Y�vV��3ɑ�K���i_��ǒ:#k{��0y���Է���/�U(Fh��k .jr`W{��&}��2�=1+nOEu�lGT�ę�zSI!
a�w
b��[��8����D�����R�|8�`��!V�r�E���1��r2
'Ad!�
G��k�6^%��C׬�k��$��ލC��V���I��-n61��G��z$0�$x��V����i,(قi�����9�d
6�j)�GchX��Ʒ�~�Ȟe��a���[�T5��<xgRP2�,���x�