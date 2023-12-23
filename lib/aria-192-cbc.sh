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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Љ0?�Pk�}�?��1Z~@�<�r�}�L�2,5w�̎Ίǆ^�3}����1m�~�?�:�z�)8�����}|�4�w�}E�ZC����7ɚ�������W�X
o#~�҂5�W�C�:���ޛ��ANeF]�D���g�^�b���f��-d����ӫ���5��wr���:��,`Ic������-�,����������*i���$晄9hP$9[��3��b#���{#��bJ�L"���阯8����U� q�4|u��x�/�:iz��/�������V����͉jp�#C��w�Z,�����K�a��.1����Ć_Q�[I�Z���YmZD��0.�ѥm~7���KI��1�J�=��#�11w'�$x&v��6�Lǈj-,���֯h)�g��0h�q*��	Ĵ��ѧ��f��9�p\wZ��u��5k��_�����
��ø�ɓ<�藾�s��r����a��/Բ�iy���`vj^|�!���*kD9_��o�;�E>>����~�atx�����/,�C�g��/�;h��*�)p*��'/ɑ\���c��+60�]�����=4�����1�2�q��ٓ:ek#c�!�!/]u��M~�	���j����N�Y��9��R.��v�)�[��ΒeɁ׾�a�
��YM^���J�pWJ����t�r�7�){�[ ����"8�$�O�ot&0�F�P-/uO�UcDCT�	��Χ����4��]ʫ(aA5yҦwn(��UN���?�w�^Z�O�:� �������j�wq�L�p��{�2If<2~ۼu5�v�,Hم�r�0p��[����%�U��DN)=g�H\�N52�K���rf��L=O�W�D�B<El��Ƌ�d��;�ef�_`	���utr^)�ИJ����٘�����tb]���bL���N��椥D3	���Jz9�2P����Th.x�O��B�`;Y􅰅��Q��*�B���pҒ� �x�6��;?��o8�,��EM2H~'(2星ܓ�\�zC`�ݕ���v8���#� ��3�@���EnO5�ށq
�CDZ:?,���z��E��j6�j�d㕸F�".��@�QXа���JwH��=r�D�%���D�5�%e��]]䴁�{�ܙ 4��-����'��f�d1s�;8�"��D�:�<6�Tح�&
�h� ~i��O�Z��!�X��";�1�niVuz��n�w��.r��N���:fٔ)�rG�_��`����������R��^��ǎ�{Nӝ!}jx�ϗc�jd���ݝJ��m	��&ZK�j�`�.:��A��7/ޞ'噅Ɣ%�p�R����[�7��.�5�C~$�����gb�`W����yX`7hP@ �-Q�����,fj�&���;C5�%�I�+�m�P�����U-;����f'gW���]EWV��c��$0�P#���)���ja*���������5#
��>��m�Q��Vh�ٲ+,i�C����
Lr��40���}S`�8}�}f��t�ayqU��q�O�A�x�0�����Uds]9��V�ָ��\�����,�+	/ Øߤ]�8�JX�C/1���� �L�~'�gΦF��T�}�yP����A�7�)E��K/[]��[`ݛک�A@x�9�%{� �Y���c�ћ���v!=:���Mއ�� t5����i��i��
�F�����'H�֊F"�
��P#�@%3��mb��Ux�}їr����u p�������O���п\B�����8{ut�K((�V�0�_i��t�m&P�'(������D�)���Z+�T��@CJ�֜�[�/@�V�܌S�ܾ���b��ldO2U�7�^ ����z!a�^G}�8̼������r*#[�^|�f�:��Z)���V���DR������v���7Ӈ�5�_���o��I^�|�s��MD]�#c$�0��53P%�V�o*�㈜鷲�7�p��бC"�8Ne0��i��-P"��Dd�0����k��I�i8#������_V�'� ��q��w�0AUfT�A#�`���hԏ�xsǃt,�p��6]S��,�8�A?�s ��V �}�b���?�����"�$�oJ�!uY[�F�l���aF3�T�R��ƻ�X��yL�Z�؞ 7�岇F 9"W��v���g�$6p�T�Rr�]����ǲr�	fƶ�h�2�$<���(.+U���;����3�ڕ5'���"�\!-��6b2�Nф�w26�E��/r�u�n��:���cz��ڐ'��B{_ď���Wc� ��TO4,BYzEw�ZMm��$��E�M��P��?��P=9�/:iCe��M[�d��7�\x�σ2>Ɯ�0$8F�ơPj)�F��Æ�J�4�t;�<��a)Dj���N���6^s�a��gu%�j8?qA _�B{����J�?��� H��'���®z5���I �NH�]�ۇk(�P� �����L�OI9���׶  �i�����j��/M�������$��d�[�A��͜�)���O\z�������0,�?ʇ}1�cj��%�K�̆5�㇞)�\X�����a�׬�}V�ց:4�DO����cY�Ic�ȵ�:])m��3`P�Ǝ��q���p�4/^��~��g�}�6�*���|�Ƀ��c@��/�2���5Q��S;fzC����>u��
�M���-w�8.�1�ڵy�1�j\[g`�_���³&"֯���7��W���qd�-�mH����x��z/��\��N̛�N�3쑀����J]��ƒF
zq��޴&���!{|�NTg��ԅ��N��D-���F�FCQÁT��W��3�!�R�C:�M1�� �ң)��TI��]k��'��@oSb}+��^���t}`-
�5�q>4�{u]���Ί�݉U��3��ɜ��5��Ow��V���]��]�9�����$���\B�C����������!�(��LL99�H��H�p��C�ca@���f���U{A��x�#�<+���DI�V�ѽ��+}��|镹�Ë�J��h#G'�AZy�[tFrt	�V�Մ�e�*!�Hz1�d�&Ȓ����}�Z�-{�R֭�;u/^z�: l�M;��J��F~����M�kV;��{�t�p����B� ���4�D;��9AKߎ�C� i^pG5�nh�A�c(���i:�����H��7l��d�1QR�Y���$ʥKQ��=��9�vS����~�R��~���g��|����oL�$S�[S�����[=h!羝)ke ��
�L��I´=Q�G���f=yH�����6�r�m�qSl4c���}�:����'�<�d]�z�FR�N��n��n���84^{��,��3ήl��nUL�87F�� �	E���Q2�'��PTRs+�dw���g/b���H�~Ú~5�����yPz�%�Q���TJ��_d�����-gZ�~�%��(�V��Y���O�>@kD�Y�h ��DtD�iK��w��P1����&O!�H�w�������;�Q��.jq{�C���0L�)�����.ͮ&�d'3V����"��A��V���(��N��W���NR?Fn:tE����朾��=��p�=\;>�"�!L)Y�~��7a���(C�l��&ŝ�G�E�����I� �c��5$d����7�皿k��Q��:��{쮍�ʚ�O-�ؿs����^�o@S�-���H�������l���([�ۉ���0jэe�%h^[�����6g�]5ޫ�޵�q�ō-��Ƭy�e|a����g��b�ן��ؘ�����t=����C���^�!�~-�Q�����wm�g{���x5_y���¬
l7�T1�����z���$�z��wf�K�s�RM���kpnlv� ���-�f�+�քz����c�9:���ș�*+��(n�G���н�T�凢�C�_��~ߚ